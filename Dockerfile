FROM golang:1.15 AS build-env
COPY . /build
WORKDIR /build

# execute tests
RUN go test ./... -cover

## ONLY tests so far, building to be added later
# execute build
# with `-tags release` we ensure that shared test utilities won't end up in the binary
RUN export GIT_COMMIT=$(git rev-parse HEAD) && \
    export GIT_REPOSITORY=$(git config --get remote.origin.url) && \
    CGO_ENABLED=0 go build \
        -ldflags \
            "-X github.com/SerkanGitRepo/jenkins-library/cmd.GitCommit=${GIT_COMMIT} \
            -X github.com/SerkanGitRepo/jenkins-library/pkg/log.LibraryRepository=${GIT_REPOSITORY} \
            -X github.com/SerkanGitRepo/jenkins-library/pkg/telemetry.LibraryRepository=${GIT_REPOSITORY}" \
        -tags release \
        -o piper

# FROM gcr.io/distroless/base:latest
# COPY --from=build-env /build/piper /piper
# ENTRYPOINT ["/piper"]
