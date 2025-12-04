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

  }
  tools {
    maven 'Maven 3.9.6'
  }
}