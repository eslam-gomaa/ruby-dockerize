pipeline {
  environment { 
    registry = "eslamgomaa/task" 
    registryCredential = 'docker_hub_id' 
    dockerImage = '' 
  }
  agent { node { label 'debian-11-vm' } }
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
        sh  "docker build -t eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER} -f Dockerfile.production ."
      }
    }
    stage('Push') {
      steps {
        script { 
          docker.withRegistry( 'eslamgomaa/task', 'docker_hub_id' ) { 
            docker.image("eslamgomaa/dockerizing-ruby-drkiq").push("latest")
            }
          }   
        // docker.withRegistry('eslamgomaa/task', 'docker_hub_id') {
        //     docker.image("eslamgomaa/dockerizing-ruby-drkiq").push("${env.BUILD_NUMBER}")
        // }
      }
    }
  }
}