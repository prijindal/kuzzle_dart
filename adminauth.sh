#!/bin/sh

curl -X POST "http://localhost:7512/_createFirstAdmin" --data '{"content":{"name":"admin"},"credentials": {"local": {"username": "admin", "password": "admin"}}}' -H "Content-Type: application/json"