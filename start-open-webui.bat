@echo off

:docker_loop
timeout 3
docker version
IF %errorlevel% NEQ 0 GOTO docker_loop
cd %homepath%\Documents\GitHub\open-webui\
docker run -d -p 3000:8080 -v ollama:/root/.ollama -v open-webui:/app/backend/data --name open-webui --restart always ghcr.io/open-webui/open-webui:ollama

:browser_loop
timeout 3
FOR /f "delims=" %%a in ('docker container inspect -f '{{.State.Status}}' open-webui') do @set open-webui_status=%%a
IF %open-webui_status%=='running' (
    timeout 3
    start brave --incognito "http://localhost:3000"
) ELSE (
    GOTO :browser_loop
)