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
              docker.withRegistry('https://index.docker.io/v2/', 'dockerlogin') {
                def commitHash = env.GIT_COMMIT.take(7)
                def dockerImage = docker.build("abhayasing/sysfoo:${commitHash}")

                dockerImage.push()              // Push commit-based tag
                dockerImage.push("latest")      // Push latest
                dockerImage.push("dev")         // Push dev tag
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