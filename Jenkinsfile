pipeline {
  environment { 
    registry = "eslamgomaa/task" 
    registryCredential = 'docker_hub_id' 
    dockerImage = '' 
  }
  agent any
  stages {
    stage('Cloning Git Repo') { 
      steps { 
        git branch: 'main',
            credentialsId: 'f0a87b6b-822e-4502-8051-47a170675cc3',
            url: 'https://github.com/eslam-gomaa/ruby-dockerize.git'
        // sh 'git clone https://github.com/eslam-gomaa/ruby-dockerize.git' 
      }
    } 
    stage('Build') {
      steps {
        echo 'Build the app locally & run tests'
        pwsh(script: """
            pwd
            ls -lh
            //  cd ruby-dockerize
            //  docker build -t eslamgomaa/dockerizing-ruby-drkiq:latest \
            //     --cache-from=eslamgomaa/dockerizing-ruby-drkiq:latest \
            //     -f Dockerfile.production .
        """)
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