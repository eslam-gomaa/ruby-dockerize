pipeline {
  environment { 
    registry = "https://registry.hub.docker.com/eslamgomaa" 
    registryCredential = 'docker_hub_id' 
    dockerImage = '' 
  }
  agent { node { label 'build-pod-staging' } }
  stages {
    stage('Cloning Git Repo') { 
      steps { 
        git branch: 'main',
            credentialsId: 'f0a87b6b-822e-4502-8051-47a170675cc3',
            url: 'https://github.com/eslam-gomaa/ruby-dockerize.git'
        // sh 'git clone https://github.com/eslam-gomaa/ruby-dockerize.git' 
      }
    }
    stage('Build & Test') {
      steps {
        echo 'Build the app locally & run tests'
        sh  "docker build -t eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER} --cache-from=eslamgomaa/dockerizing-ruby-drkiq:latest -f Dockerfile.production ."
      }
    }
    stage('Push') {
      steps {
        script { 
          docker.withRegistry( registry, registryCredential ) { 
            docker.image("eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER}").push("${env.BUILD_NUMBER}")
            docker.image("eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER}").push("latest")
          }
        }   
      }
    }
    stage('Deploy on Staging ENV') {
      steps {
        node('build-pod-staging') {
          sh 'ls k8s-app/'
        }
      }
    }
  }
}
