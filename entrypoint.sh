#!/bin/sh


#!/bin/bash
dir_flag="--input-dir"

if [ "${INPUT_FIREBASE_CTL_ACTION}" == "get" ]; then
    dir_flag="--output-dir"
fi
test_output=$(echo hello)

test_exit_code=1

    # exit code 0 - success
    if [ ${test_exit_code} -eq 0 ];then
        test_comment_status="Success"
        echo "test: info: successful ${INPUT_FIREBASE_CTL_ACTION} on ${INPUT_FIREBASE_CTL_DIR}."
        echo $test_output
        echo
    fi

    # exit code !0 - failure
    if [ ${test_exit_code} -ne 0 ]; then
        test_comment_status="Failed"
        echo "test: error: failed ${INPUT_FIREBASE_CTL_ACTION} on ${INPUT_FIREBASE_CTL_DIR}."
        echo ${test_output}
        echo
    fi

    # comment if test failed
    if [ "${GITHUB_EVENT_NAME}" == "pull_request" ] && [ ${test_exit_code} -ne 0 ]; then
        test_comment_wrapper="#### \`test\` ${test_comment_status}
<details><summary>Show Output</summary>

\`\`\`
${test_output}
 \`\`\`
</details>

*Workflow: \`${GITHUB_WORKFLOW}\`, Action: \`${GITHUB_ACTION}\`, test: \`${INPUT_FIREBASE_CTL_DIR}\`*"
    
        echo "test: info: creating json"
        test_payload=$(echo "${test_comment_wrapper}" | jq -R --slurp '{body: .}')
        test_comment_url=$(cat ${GITHUB_EVENT_PATH} | jq -r .pull_request.comments_url)
        echo "test: info: commenting on the pull request"
        echo "${test_payload}" | curl -s -S -H "Authorization: token ${GITHUB_ACCESS_TOKEN}" --header "Content-Type: application/json" --data @- "${test_comment_url}" > /dev/null
    fi
echo $test_comment_wrapper
echo ::set-output name=test_output::${test_output}
exit ${test_exit_code}