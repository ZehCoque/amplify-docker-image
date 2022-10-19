FROM amazonlinux:2

WORKDIR /codebuild   

RUN curl -sL https://rpm.nodesource.com/setup_16.x | bash 
RUN yum -y install nodejs
RUN yum install git -y
RUN yum install openssh -y
RUN yum install awscli -y
RUN yum install unzip -y
RUN yum install which -y
RUN npm install -g typescript glob
RUN npm link glob
RUN yum -y update && yum install -y sudo
RUN sudo rpm --import https://yum.corretto.aws/corretto.key
RUN sudo curl -L -o /etc/yum.repos.d/corretto.repo https://yum.corretto.aws/corretto.repo
RUN sudo yum install -y java-11-amazon-corretto-devel
ENV JAVA_HOME=/usr/lib/jvm/java-11-amazon-corretto

WORKDIR /codebuild/android-sdk
RUN curl https://dl.google.com/android/repository/commandlinetools-linux-8512546_latest.zip -o android-sdk.zip 
RUN sudo unzip android-sdk.zip -d .
RUN sudo rm android-sdk.zip
RUN mkdir cmdline-tools/latest && mv cmdline-tools/bin cmdline-tools/latest/ && mv cmdline-tools/lib cmdline-tools/latest/
RUN sudo cmdline-tools/latest/bin/sdkmanager "tools"
RUN yes | sudo cmdline-tools/latest/bin/sdkmanager --licenses
RUN ./cmdline-tools/latest/bin/sdkmanager "build-tools;32.0.0"
ENV ANDROID_HOME=/codebuild/android-sdk
ENV PATH=$PATH:$ANDROID_HOME/build-tools/32.0.0

WORKDIR /codebuild/gradle
RUN curl -L https://services.gradle.org/distributions/gradle-7.4.2-all.zip -o gradle-7.4.2-all.zip
RUN unzip gradle-7.4.2-all.zip -d .
RUN sudo rm gradle-7.4.2-all.zip
ENV GRADLE_HOME=/codebuild/gradle/gradle-7.4.2
ENV PATH=$PATH:$GRADLE_HOME/bin