FROM ubuntu

# LABEL about the custom image
LABEL maintainer="st173207@stud.uni-stuttart.de"
LABEL version="1.1"
LABEL description="This is custom Docker Image for \
ITOM in Linux."
# Environment variable will not prompt to install time zone etc when we use apt get install 
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt-get update

# Dependencies of ITOM
RUN apt-get install -y \
    build-essential \
    cmake \
    cmake-qt-gui \
    git \
    python3 \
    python3-dev \
    python3-numpy \
    python3-pip \
    python3-apt-dbg \
    libqt5webkit5 \
    libqt5webkit5-dev \
    libqt5widgets5 \
    libqt5xml5 \
    libqt5svg5 \
    libqt5svg5-dev \
    libqt5gui5 \
    libqt5designer5 \
    libqt5concurrent5 \
    qttools5-dev-tools \
    qttools5-dev \
    libopencv-dev \
    python3-opencv \
    libv4l-dev \
    xsdcxx \
    libxerces-c3.2 \
    libxerces-c-dev \
    qtwebengine5-dev \
    libqt5webengine5 \
    libqt5webenginewidgets5 \
    libv4l-dev && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
# Obtain the sources for Linux in Default folder structure for ITOM :

RUN mkdir itom 
#&&\
    #mkdir itom/sources &&\
    #mkdir itom/build_releases &&\
    #mkdir itom/sources/itom &&\
    #mkdir itom/build_releases/itom

RUN bash -c 'mkdir -p itom/{sources,build_debug,build_release}/{itom,plugins,designerplugins}'
    
RUN git clone https://bitbucket.org/itom/itom.git ./itom/sources/itom &&\
    git clone https://bitbucket.org/itom/plugins.git ./itom/sources/plugins &&\
    git clone https://bitbucket.org/itom/designerplugins.git ./itom/sources/designerplugins

     
WORKDIR itom/build_release/itom
RUN cmake -G "Unix Makefiles" -DBUILD_WITH_PCL=OFF -DCMAKE_BUILD_TYPE=Release ../../sources/itom && \
    make -j4

WORKDIR ../designerplugins
RUN cmake -G "Unix Makefiles" -DBUILD_WITH_PCL=OFF -DCMAKE_BUILD_TYPE=Release -DITOM_SDK_DIR=../itom/SDK ../../sources/designerplugins && \
    make -j4

WORKDIR ../plugins
RUN cmake -G "Unix Makefiles" -DBUILD_WITH_PCL=OFF -DCMAKE_BUILD_TYPE=Release -DITOM_SDK_DIR=../itom/SDK ../../sources/plugins && \
    make -j4

WORKDIR ../itom
#CMD "./qitom"
