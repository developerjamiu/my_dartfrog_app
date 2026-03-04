FROM dart:stable AS build

WORKDIR /app
COPY . .

# Install Dart Frog CLI and build
RUN dart pub global activate dart_frog_cli
RUN dart pub get
RUN dart pub global run dart_frog build

# Compile the generated server
RUN dart build cli --target build/bin/server.dart -o output

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/output/bundle/ /app/
EXPOSE 8080
CMD ["/app/bin/server"]