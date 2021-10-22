pipeline {
  agent any
  stages {
    stage('Stage1') {
      steps {
        echo 'Build the app locally & run tests'
      }
    }
    stage('Verify Branch') {
    steps {
      echo "$GIT_BRANCH"
    }
      }
    // stage('Docker Build') {
    //     steps {
    //       pwsh(script: 'docker images -a')
    //       pwsh(script: """
    //           cd azure-vote/
    //           docker images -a
    //           docker build -t jenkins-pipeline .
    //           docker images -a
    //           cd ..
    //       """)
    //     }
    // }
  }
}