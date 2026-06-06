# railapi (Railway API) 
Backend APIs (for Railm) to Crowd-Source and maintain train running status with repository for stations, routes and trains.

# Build Instruction
### Dependencies
- go v1.24.x
- trubodb

## Build
### Server
```bash
export TURSO_DATABASE_URL="<url>";
export TURSO_DATABASE_TOKEN="<token>";
export PORT="8080";

go build -o build/server cmd/server/main.go # build
./build/server # run
```

### Run from prebuild binaries
```bash
TURSO_DATABASE_URL="<url>" TURSO_DATABASE_TOKEN="<token>" PORT="8080" ./railapi-<arch>-v26xx.x
```

### Insert Test Data
Only required for initial turbodb setup.
```bash
# run the server first
# then insert datas
./data/insert.py data/test-data.json
```

# Info
Read api-docs.txt to learn how the web api works.
