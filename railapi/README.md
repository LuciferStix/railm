# railapi (Railway API) 
Backend APIs (for Railm) to Crowd-Source and maintain train running status with repository for stations, routes and trains.

# Build Instruction
### Dependencies
- go v1.24.x
- sqlite3

## Build
### Server
```bash
go build -o build/server cmd/server/main.go # build
./build/server # run
```

### Insert Test Data
```bash
# run the server first
# then insert datas
./data/insert.py data/test-data.json
```

# Info
Read api-docs.txt to learn how the web api works.
