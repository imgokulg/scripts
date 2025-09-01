import fitz  # PyMuPDF
import os

def extract_images_from_pdf(pdf_path, output_folder):
    # Open the PDF
    pdf_file = fitz.open(pdf_path)

    # Make sure output folder exists
    os.makedirs(output_folder, exist_ok=True)
    
    file_name_with_ext = os.path.basename(pdf_path)

    # Get file name without extension
    file_name_no_ext = os.path.splitext(file_name_with_ext)[0]

    # Loop through pages
    for page_num in range(len(pdf_file)):
        page = pdf_file[page_num]
        images = page.get_images(full=True)

        for img_index, img in enumerate(images, start=1):
            xref = img[0]  # Reference to the image
            pix = pdf_file.extract_image(xref)
            img_bytes = pix["image"]
            img_ext = pix["ext"]

            # Save image
            img_filename = os.path.join(output_folder, f"{file_name_no_ext}_page{page_num+1}_img{img_index}.{img_ext}")
            with open(img_filename, "wb") as img_file:
                img_file.write(img_bytes)

            print(f"Saved: {img_filename}")

    pdf_file.close()

# Example usage
extract_images_from_pdf("SAMRITHA DENTAL CLINIC.pdf", "extracted_images")
