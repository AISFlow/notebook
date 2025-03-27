FROM glcr.b-data.ch/jupyterlab/r/verse:4.4.3 AS bedrock
FROM bedrock AS files

USER root
WORKDIR /files

COPY --link assets /files

## Copy custom fonts
RUN mkdir -p /files/usr/local/share/jupyter/lab/static/assets && \
    mkdir -p /files/usr/local/share/jupyter/lab/static/assets/css && \
    mkdir -p /files/usr/local/share/jupyter/lab/static/assets/fonts && \
    cp -a /files/opt/code-server/src/browser/media/css/* \
        /files/usr/local/share/jupyter/lab/static/assets/css/ && \
    cp -a /files/opt/code-server/src/browser/media/fonts/*.woff \
        /files/usr/local/share/jupyter/lab/static/assets/fonts/ && \
    cp -a /files/opt/code-server/src/browser/media/fonts/*.woff2 \
        /files/usr/local/share/jupyter/lab/static/assets/fonts/ && \
    mkdir -p /files/etc/rstudio/fonts && \
    cp /files/opt/code-server/src/browser/media/fonts/*.woff \
        /files/etc/rstudio/fonts/ && \
    cp /files/opt/code-server/src/browser/media/fonts/*.woff2 \
        /files/etc/rstudio/fonts/ && \
    find /files -type d -exec chmod 755 {} \; && \
    find /files -type f -exec chmod 644 {} \;

ARG D2CODING_VERSION=1.3.2
ARG D2CODING_DATE=20180524
ARG D2CODING_NERD_VERSION=1.3.2
ARG PRETENDARD_VERSION=1.3.9

RUN set -eux; \
        install_google_font() { \
        local relative_path="$1"; local font_name="$2"; \
        local font_dir="/usr/share/fonts/truetype/${relative_path}"; \
        mkdir -p "${font_dir}" && \
        local encoded_font_name=$(printf "%s" "${font_name}" | jq -sRr @uri); \
        wget --quiet -O "${font_dir}/${font_name}" "https://raw.githubusercontent.com/google/fonts/17216f1645a133dbbeaa506f0f63f701861b6c7b/ofl/${relative_path}/${encoded_font_name}"; \
    }; \
    \
    # Install the D2Coding font
    mkdir -p /usr/share/fonts/truetype/D2Coding && \
        wget --quiet -O /usr/share/fonts/truetype/D2Coding.zip "https://github.com/naver/d2codingfont/releases/download/VER${D2CODING_VERSION}/D2Coding-Ver${D2CODING_VERSION}-${D2CODING_DATE}.zip" && \
        unzip /usr/share/fonts/truetype/D2Coding.zip -d /usr/share/fonts/truetype/ && \
    rm /usr/share/fonts/truetype/D2Coding.zip && \
    \
    # Install the D2Coding Nerd font
    mkdir -p /usr/share/fonts/truetype/D2CodingNerd && \
    wget --quiet -O /usr/share/fonts/truetype/D2CodingNerd/D2CodingNerd.ttf "https://github.com/kelvinks/D2Coding_Nerd/raw/master/D2Coding%20v.${D2CODING_NERD_VERSION}%20Nerd%20Font%20Complete.ttf" && \
    \
    # Install the Pretendard and PretendardJP fonts
    mkdir -p /usr/share/fonts/truetype/Pretendard && \
        wget --quiet -O /usr/share/fonts/truetype/Pretendard.zip "https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/Pretendard-${PRETENDARD_VERSION}.zip" && \
        unzip /usr/share/fonts/truetype/Pretendard.zip -d /usr/share/fonts/truetype/Pretendard/ && \
    rm /usr/share/fonts/truetype/Pretendard.zip && \
    mkdir -p /usr/share/fonts/truetype/PretendardJP && \
        wget --quiet -O /usr/share/fonts/truetype/PretendardJP.zip "https://github.com/orioncactus/pretendard/releases/download/v${PRETENDARD_VERSION}/PretendardJP-${PRETENDARD_VERSION}.zip" && \
        unzip /usr/share/fonts/truetype/PretendardJP.zip -d /usr/share/fonts/truetype/PretendardJP/ && \
    rm /usr/share/fonts/truetype/PretendardJP.zip && \
    \
    # Install Noto fonts
        install_google_font "notosans" "NotoSans[wdth,wght].ttf" && \
        install_google_font "notosans" "NotoSans-Italic[wdth,wght].ttf" && \
        install_google_font "notoserif" "NotoSerif[wdth,wght].ttf" && \
        install_google_font "notoserif" "NotoSerif-Italic[wdth,wght].ttf" && \
        install_google_font "notosanskr" "NotoSansKR[wght].ttf" && \
        install_google_font "notoserifkr" "NotoSerifKR[wght].ttf" && \
        install_google_font "notosansjp" "NotoSansJP[wght].ttf" && \
        install_google_font "notoserifjp" "NotoSerifJP[wght].ttf" && \
    \
    # Install Nanum fonts
        install_google_font "nanumbrushscript" "NanumBrushScript-Regular.ttf" && \
        install_google_font "nanumgothic" "NanumGothic-Bold.ttf" && \
        install_google_font "nanumgothic" "NanumGothic-ExtraBold.ttf" && \
        install_google_font "nanumgothic" "NanumGothic-Regular.ttf" && \
        install_google_font "nanumgothiccoding" "NanumGothicCoding-Bold.ttf" && \
        install_google_font "nanumgothiccoding" "NanumGothicCoding-Regular.ttf" && \
        install_google_font "nanummyeongjo" "NanumMyeongjo-Bold.ttf" && \
        install_google_font "nanummyeongjo" "NanumMyeongjo-ExtraBold.ttf" && \
        install_google_font "nanummyeongjo" "NanumMyeongjo-Regular.ttf" && \
    \
    # Install IBM Plex fonts
        install_google_font "ibmplexmono" "IBMPlexMono-Bold.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-BoldItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-ExtraLight.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-ExtraLightItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Italic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Light.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-LightItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Medium.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-MediumItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Regular.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-SemiBold.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-SemiBoldItalic.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-Thin.ttf" && \
        install_google_font "ibmplexmono" "IBMPlexMono-ThinItalic.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Bold.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-ExtraLight.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Light.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Medium.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Regular.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-SemiBold.ttf" && \
        install_google_font "ibmplexsanskr" "IBMPlexSansKR-Thin.ttf" && \
    \
    # Set font permissions and update the cache
    chmod -R 644 /usr/share/fonts/truetype/* && \
    find /usr/share/fonts/truetype/ -type d -exec chmod 755 {} + && \
    fc-cache -fsv

FROM bedrock AS layer-cutter

USER root

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential g++ pkg-config \
        wget curl git git-lfs openssh-client \
        unzip zip tar \
        dumb-init procps htop lsb-release locales jq \
        pandoc ffmpeg \
        libx11-dev libxkbfile-dev libsecret-1-dev libkrb5-dev \
        libpq-dev \
        fonts-dejavu fontconfig fonts-noto-cjk \
        texlive-lang-korean texlive-lang-chinese texlive-lang-japanese \
        texlive-xetex texlive-fonts-recommended \
        ko.tex && \
    locale-gen ko_KR.UTF-8 && \
    rm -rf /tmp/* \
        /var/lib/apt/lists/* \
        ${HOME}/.cache \
        ${HOME}/.config \
        ${HOME}/.ipython \
        ${HOME}/.local

COPY --link --from=files /files /
COPY --link --from=files /usr/share/fonts/truetype /usr/share/fonts/truetype

RUN sed -i 's|</head>|<link rel="stylesheet" type="text/css" href="{{page_config.fullStaticUrl}}/assets/css/korean.css"></head>|g' /usr/local/share/jupyter/lab/static/index.html && \
    sed -i 's|</head>|<link rel="stylesheet" type="text/css" href="{{page_config.fullStaticUrl}}/assets/css/japanese.css"></head>|g' /usr/local/share/jupyter/lab/static/index.html && \
    sed -i 's|</head>|	<link rel="stylesheet" type="text/css" href="{{BASE}}/_static/src/browser/media/css/korean.css">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html && \
    sed -i 's|</head>|	<link rel="stylesheet" type="text/css" href="{{BASE}}/_static/src/browser/media/css/japanese.css">\n	</head>|g' /opt/code-server/lib/vscode/out/vs/code/browser/workbench/workbench.html && \
    rm -rf /tmp/* \
    ${HOME}/.cache

## Switch back to ${NB_USER} to avoid accidental container runs as root
USER ${NB_USER}

FROM bedrock AS final

USER root

RUN apt-get update && \
    apt-get install -yq --no-install-recommends \
        build-essential g++ pkg-config \
        wget curl git git-lfs openssh-client \
        unzip zip tar \
        dumb-init procps htop lsb-release locales jq \
        pandoc ffmpeg \
        libx11-dev libxkbfile-dev libsecret-1-dev libkrb5-dev \
        libpq-dev \
        fonts-dejavu fontconfig fonts-noto-cjk \
        texlive-lang-korean texlive-lang-chinese texlive-lang-japanese \
        texlive-xetex texlive-fonts-recommended \
        ko.tex && \
    locale-gen ko_KR.UTF-8 && \
    rm -rf /tmp/* \
        /var/lib/apt/lists/* \
        ${HOME}/.cache \
        ${HOME}/.config \
        ${HOME}/.ipython \
        ${HOME}/.local

RUN pip install --no-cache-dir \
        selenium \
        nbconvert[webpdf] \
        ipympl \
        jupyterlab-latex \
        jupyterlab-katex \
        ipydatagrid \
        jupyterlab-language-pack-ko-KR \
        git+https://github.com/AISFlow/nbconvert.git && \
    rm -rf /tmp/* \
        /var/lib/apt/lists/* \
        ${HOME}/.cache \
        ${HOME}/.config \
        ${HOME}/.ipython \
        ${HOME}/.local

COPY --link --from=layer-cutter /usr/share/fonts /usr/share/fonts
COPY --link --from=layer-cutter /usr/local/share/jupyter/lab/static/assets /usr/local/share/jupyter/lab/static/assets
COPY --link --from=layer-cutter /opt/code-server /opt/code-server
COPY --link --from=layer-cutter /etc/rstudio/fonts /etc/rstudio/fonts

USER ${NB_USER}