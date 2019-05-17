#!/bin/bash
set -e
set -x

function uploadToGithubPagesRepo() {
  git init
  git add .
  git config user.name "${GH_USER_NAME}"
  git config user.email "${GH_USER_EMAIL}"
  git commit -m "Updating ChatEngine Docs on gh-pages: ${TRAVIS_COMMIT_MESSAGE}"
  git push --force --quiet "https://${GH_TOKEN_PUBLISH_DOCS}@github.com/pubnub/chat-engine-server.git" master:gh-pages
  return
}

function cloneGitRepo() {
  REPO_TO_CLONE="${1}"
  if [ REPO_TO_CLONE != "" ]; then
    git clone "https://${GH_TOKEN_PUBLISH_DOCS}@github.com/pubnub/${REPO_TO_CLONE}.git"
  fi
  return
}

## RUN
echo "compiling js_docs with plugin assets..."
gulp build-docs
if [ "${TRAVIS_BRANCH}" == "master" ] \
  && [ "${TRAVIS_PULL_REQUEST}" == "false" ]; then
    # Build the JS_DOCs into docs/ dir
    pushd build/api-docs/
    uploadToGithubPagesRepo
    popd
fi
