#!/bin/bash
docker build -t mon_app .
docker run -d -p 8000:8000 mon_app
