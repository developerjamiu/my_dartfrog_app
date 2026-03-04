FROM dart:stable AS build

WORKDIR /app

# Copy the entire project (Dart Frog needs the full directory structure for code generation)
COPY . .

# Install the Dart Frog CLI and add it to PATH
RUN dart pub global activate dart_frog_cli
ENV PATH="/root/.pub-cache/bin:${PATH}"

# Resolve dependencies
RUN dart pub get

# Generate the server code from your route definitions
RUN dart_frog build

# Compile the generated server
RUN dart build cli --target build/bin/server.dart -o output

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/output/bundle/ /app/
EXPOSE 8080
CMD ["/app/bin/server"]