pipeline {
  agent none
  stages {
    stage('Maven Install') {
      agent {
        docker {
          image 'maven:3.6.3-jdk-11'
          args '-v /root/.m2:/root/.m2'
        }
      }
      stages {
        stage('Build') {
          steps {
            sh 'mvn -B -DskipTests clean package'
          }
        }
        stage('Test') {
          steps {
            sh 'mvn test'
          }
        }
      }
    }
    stage('Deliver - build docker image') {
      agent any
      steps {
        sh 'docker build . -t calculator:1.0'
      }
    }
    stage('Deliver - push docker image') {
        agent any
        steps {
          withCredentials([usernamePassword(credentialsId: 'dockerHub', passwordVariable:'dockerHubPassword', usernameVariable: 'dockerHubUser')]) {
            sh "docker login -u ${env.dockerHubUser} -p ${env.dockerHubPassword}"
            sh 'docker tag calculator:1.0 soumithk/calculator:1.0'
            sh 'docker push soumithk/calculator:1.0'
          }
        }
    }
    stage('Deploy - rundeck') {
      agent any
      steps {
        script {
          step([$class: "RundeckNotifier",
          rundeckInstance: "rundeck",
          jobId: "e93463da-66f6-4d64-9b0a-fa2806e6ebe8"])
        }
      }
    }
  }
}
