pipeline {
  environment { 
    registry = "https://registry.hub.docker.com/eslamgomaa" 
    registryCredential = 'docker_hub_id' 
    dockerImage = '' 
  }
  agent {
    kubernetes {
      yaml '''
        apiVersion: v1
        kind: Pod
        metadata:
          name: cd
          label:
            app: rails
        spec:
          containers:
          - name: docker
            image: docker:18.03-git
            command: ["sleep"]
            args: ["100000"]
            tty: true
            volumeMounts:
            - name: docker-socket
              mountPath: /var/run/docker.sock
            workingDir: /workspace
          - name: kubectl
            image: vfarcic/kubectl
            command: ["sleep"]
            args: ["100000"]
            tty: true

            workingDir: /workspace
          volumes:
          - name: docker-socket
            hostPath:
              path: /var/run/docker.sock
              type: Socket

        '''
    }
  }
  stages {
    stage('Cloning Git Repo') { 
      steps { 
        git branch: 'main',
            credentialsId: 'f0a87b6b-822e-4502-8051-47a170675cc3',
            url: 'https://github.com/eslam-gomaa/ruby-dockerize.git'
        sh 'pwd'
        sh 'ls -lh'
      }
    }
    stage('Build') {
      steps {
        container('docker') {
          sh 'ls -lh'
          echo 'Build the app locally & run tests'
          sh  "docker build -t eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER} --cache-from=eslamgomaa/dockerizing-ruby-drkiq:latest -f Dockerfile.production ."
        }
      }
    }
    stage('Push') {
      steps {
        container('docker') {
          script { 
            docker.withRegistry( registry, registryCredential ) { 
              docker.image("eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER}").push("${env.BUILD_NUMBER}")
              docker.image("eslamgomaa/dockerizing-ruby-drkiq:${env.BUILD_NUMBER}").push("latest")
            }
          }
        }
      }
    }
    stage('Deploy on Staging namespace') {
      steps {
        container('kubectl') {
          script { 
            sh 'ls -lh'
            sh 'pwd'
            sh 'ls k8s-app/staging/'
          }
        }
      }
    }
  }
}