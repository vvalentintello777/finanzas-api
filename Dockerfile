FROM dart:stable AS build
WORKDIR /app
COPY pubspec.* ./
RUN dart pub get
COPY . .
RUN dart build cli --target bin/server.dart -o output

FROM scratch
COPY --from=build /runtime/ /
COPY --from=build /app/output/bundle/ /app/
CMD ["/app/bin/server"]
