#!/usr/bin/env bash

# activate the base (only) environment
source /opt/conda/bin/activate base
# activate FSL
source $FSLDIR/etc/fslconf/fsl.sh
exec "$@"

echo "start of processing"

# Function to process a single file
process_file() {
    local file="$1"
    base_name=$(basename "$file")
    echo "Processing file: $base_name"
    
    # Extract the modality (T1w, T2w, FLAIR, etc.) and insert _defaced before it
    defaced_name=$(echo "$base_name" | sed 's/_\([^_]*\)\.nii\.gz$/_defaced_\1.nii.gz/')
    
    echo "Creating name: $defaced_name"
    fslmaths "$file" -thr 0 "$OUTPUT_DIR/$defaced_name"
    echo "Output saved to: $OUTPUT_DIR/$defaced_name"
}

# Process all files in the input directory
echo "Processing all files in directory: $INPUT_DIR"
for file in $INPUT_DIR/*; do
    if [ -f "$file" ]; then
        # Check if file has one of the required extensions
        if [[ "$file" =~ \.(nii|nii\.gz)$ ]]; then
            process_file "$file"
        fi
    fi
done