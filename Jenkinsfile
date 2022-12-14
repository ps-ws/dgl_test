#!/usr/bin/env groovy

pipeline {
  agent any
  triggers {
        issueCommentTrigger('@Rhett-Ying .*')
  }
  stages {
    stage('CI') {
      when { not { triggeredBy 'IssueCommentCause' } }
      stages {
        stage('Unit Test') {
          agent {
            docker {
              label "linux-cpu-node"
              image "dgllib/dgl-ci-lint"
              alwaysPull false
            }
          }
          steps {
            sh 'bash task_unit_test.sh'
          }
          post {
            always {
              cleanWs disableDeferredWipeout: true, deleteDirs: true
            }
          }
        }
      }
    }
  }
  post {
    always {
      script {
        node("dglci-post-linux") {
          docker.image('dgllib/dgl-ci-awscli:v220418').inside("--pull always --entrypoint=''") {
            sh("rm -rf ci_tmp")
            dir('ci_tmp') {
              sh("curl -o cireport.log ${BUILD_URL}consoleText")
              sh("curl -L ${BUILD_URL}wfapi")
              sh("curl -o report.py https://raw.githubusercontent.com/Rhett-Ying/dgl_test/main/report.py")
              sh("curl -o status.py https://raw.githubusercontent.com/Rhett-Ying/dgl_test/main/status.py")
              sh("cat status.py")
              sh("pytest --html=report.html --self-contained-html report.py || true")
              sh("aws s3 sync ./ s3://dgl-ci-result/${JOB_NAME}/${BUILD_NUMBER}/${BUILD_ID}/logs/  --exclude '*' --include '*.log' --acl public-read --content-type text/plain")
              sh("aws s3 sync ./ s3://dgl-ci-result/${JOB_NAME}/${BUILD_NUMBER}/${BUILD_ID}/logs/  --exclude '*.log' --acl public-read")

              def comment = sh(returnStdout: true, script: "python3 status.py").trim()
              echo(comment)
              if ((env.BRANCH_NAME).startsWith('PR-')) {
                pullRequest.comment(comment)
              }
            }
          }
        }
      }
    }
  }
}
