pipeline {
  agent none
  stages {
    stage('build') {
      agent {
        docker {
          image 'maven:3.9.6-eclipse-temurin-17-alpine'
        }

      }
      steps {
        echo 'compile maven app'
        sh 'mvn compile'
      }
    }

    stage('test') {
      agent {
        docker {
          image 'maven:3.9.6-eclipse-temurin-17-alpine'
        }

      }
      steps {
        echo 'test maven app'
        sh 'mvn clean test'
      }
    }

    stage('package') {
      parallel {
        stage('package') {
          agent {
            docker {
              image 'maven:3.9.6-eclipse-temurin-17-alpine'
            }

          }
          steps {
            echo 'package maven app'
            sh ''' # Truncate the GIT_COMMIT to the first 7 characters
 GIT_SHORT_COMMIT=$(echo $GIT_COMMIT | cut -c 1-7)
 # Set the version using Maven
 mvn versions:set -DnewVersion="$GIT_SHORT_COMMIT"
 mvn versions:commit
'''
            sh 'mvn package -DskipTests'
            archiveArtifacts '**/target/*.jar'
          }
        }

        stage('Docker B&P') {
          agent any
          steps {
            script {
              docker.withRegistry('https://index.docker.io/v1/', 'dockerlogin') {
                // Fetch the full Git commit hash and truncate it to the first 7 characters
                def commitHash = sh(returnStdout: true, script: 'git rev-parse HEAD').trim().take(7)
                // Build the Docker image with the short commit hash as tag
                // replace xxxxxx with your docker hub username/org
                def dockerImage = docker.build("abhaysing/sysfoo:${commitHash}", "./")
                // Push the image tagged with the commit hash
                dockerImage.push()
                // Push additional standard tags if needed
                dockerImage.push("latest")
                dockerImage.push("dev")
              }
            }

          }
        }

      }
    }

  }
  tools {
    maven 'Maven 3.9.6'
  }
}