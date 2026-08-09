#!/usr/bin/env bash
set -euo pipefail

OWNER="mow2333"
REPO="WorldBridge"
GITEE_API="https://gitee.com/api/v5/repos/${OWNER}/${REPO}"
GH_API="https://api.github.com/repos/${OWNER}/${REPO}"
WORK="$(mktemp -d)"
trap 'rm -rf "${WORK}"' EXIT

if [[ "${GITHUB_EVENT_NAME:-}" == "release" ]]; then
  ONE=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${GH_API}/releases/tags/${GITHUB_REF_NAME}")
  RELEASES="[${ONE}]"
else
  RELEASES=$(curl -s -H "Authorization: Bearer ${GITHUB_TOKEN}" \
    "${GH_API}/releases?per_page=100")
fi

echo "${RELEASES}" | jq -c 'sort_by(.published_at) | .[]' | while read -r REL; do
  TAG=$(echo "${REL}" | jq -r .tag_name)
  NAME=$(echo "${REL}" | jq -r .name)
  BODY=$(echo "${REL}" | jq -r .body)
  echo "==> syncing ${TAG}"

  TAG_SHA=$(curl -s "${GITEE_API}/tags?per_page=100&access_token=${GITEE_TOKEN}" | jq -r --arg t "${TAG}" \
    '.[] | select(.name==$t) | .commit.sha' | head -1)
  # tag 未同步到 Gitee 时兜底用默认分支，避免 target_commitish 为空导致创建失败
  [[ -z "${TAG_SHA}" ]] && TAG_SHA="master"

  RID=$(curl -s -X GET \
    "${GITEE_API}/releases/tags/${TAG}?access_token=${GITEE_TOKEN}" | jq -r '.id')
  if [[ -n "${RID}" && "${RID}" != "null" ]]; then
    echo "!! release ${TAG} already exists on Gitee (id=${RID}), assets only"
  else
    CREATED=$(curl -s -X POST -H "Content-Type: application/json" \
      -d "$(jq -n --arg tok "${GITEE_TOKEN}" --arg t "${TAG}" --arg ts "${TAG_SHA}" --arg n "${NAME}" --arg b "${BODY}" \
        '{access_token:$tok, tag_name:$t, target_commitish:$ts, name:$n, body:$b, draft:false, prerelease:false}')" \
      "${GITEE_API}/releases")
    RID=$(echo "${CREATED}" | jq -r '.id')
    if [[ -z "${RID}" || "${RID}" == "null" ]]; then
      echo "!! create ${TAG} failed: ${CREATED}"
      continue
    fi
    echo "   created release id=${RID}"
  fi

  echo "${REL}" | jq -r '.assets[]?.name' | while read -r AN; do
    if [[ -z "${AN}" ]]; then continue; fi
    URL=$(echo "${REL}" | jq -r --arg n "${AN}" \
      '.assets[] | select(.name==$n) | .browser_download_url')
    curl -sL -o "${WORK}/${AN}" -H "Authorization: Bearer ${GITHUB_TOKEN}" "${URL}"
    RESP=$(curl -s -X POST "${GITEE_API}/releases/${RID}/attach_files" \
      -F "access_token=${GITEE_TOKEN}" -F "file=@${WORK}/${AN}")
    if echo "${RESP}" | jq -e '.name' >/dev/null 2>&1; then
      echo "   attached ${AN}"
    else
      echo "!! attach ${AN} failed: ${RESP}"
    fi
  done
done

echo "==> done"
