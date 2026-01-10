#!/bin/bash

# Supabase Database Setup Script
# This script runs the schema.sql file in your Supabase database

echo "==================================="
echo "Supabase Database Setup"
echo "==================================="
echo ""

# Check if .env file exists
if [ ! -f .env ]; then
    echo "❌ Error: .env file not found!"
    echo "Please create .env file from .env.example"
    exit 1
fi

# Load environment variables
export $(grep -v '^#' .env | xargs)

echo "📋 Configuration:"
echo "   Supabase URL: $SUPABASE_URL"
echo "   Schema file: schema.sql"
echo ""

# Check if schema.sql exists
if [ ! -f schema.sql ]; then
    echo "❌ Error: schema.sql file not found!"
    exit 1
fi

echo "🚀 Applying database schema..."
echo ""
echo "Please follow these steps to run the schema:"
echo ""
echo "1. Open Supabase Dashboard: https://app.supabase.com"
echo "2. Select your project"
echo "3. Go to SQL Editor (left sidebar)"
echo "4. Click 'New Query'"
echo "5. Copy and paste the contents of 'schema.sql'"
echo "6. Click 'Run' or press Ctrl+Enter"
echo ""
echo "Alternatively, you can run it via curl:"
echo ""
echo "curl -X POST \"$SUPABASE_URL/rest/v1/rpc/exec_sql\" \\"
echo "  -H \"apikey: $SUPABASE_KEY\" \\"
echo "  -H \"Authorization: Bearer $SUPABASE_KEY\" \\"
echo "  -H \"Content-Type: application/json\" \\"
echo "  -d @schema.sql"
echo ""
echo "==================================="
echo "✅ Schema file is ready to apply!"
echo "==================================="
