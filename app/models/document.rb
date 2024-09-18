require 'rest-client'

class Document < ApplicationRecord
  belongs_to :user
  has_one_attached :file
  has_one_attached :preview_image

  after_save :generate_preview_image

  private

  def generate_preview_image
    return unless file.attached? && !preview_image.attached?

    puts "File attached: #{file.attached?}"
    puts "File Key: #{file.key}"

    # Get the Cloudinary URL for the PDF (without query params)
    cloudinary_url = file.service.send(:url, file.key).split('?').first
    puts "Using Cloudinary URL: #{cloudinary_url}"

    # Fetch the PDF content directly
    begin
      pdf_content = RestClient.get(cloudinary_url).body
      puts "Downloaded PDF content size: #{pdf_content.size} bytes"

      if pdf_content.size.zero?
        puts "No content in the downloaded PDF."
        return
      end

      # Save the PDF content to a temporary file for MiniMagick
      temp_pdf = Tempfile.new(['document', '.pdf'])
      temp_pdf.binmode
      temp_pdf.write(pdf_content)
      temp_pdf.rewind

      # Use MiniMagick to convert the first page of the PDF to an image
      begin
        preview = MiniMagick::Image.read(temp_pdf.path) do |img|
          img.format "png"
          img.resize "300x300"
          img.page "0"  # Get the first page
        end

        puts "Generated preview image: #{preview.path}"

        # Save the preview image
        preview_image.attach(io: File.open(preview.path), filename: "preview.png", content_type: "image/png")
        puts "Preview image attached successfully."

      rescue StandardError => e
        puts "Error processing PDF to image: #{e.message}"
      ensure
        temp_pdf.close
        temp_pdf.unlink  # Delete the temporary file
      end

    rescue RestClient::ExceptionWithResponse => e
      puts "Error fetching PDF: #{e.response.code} - #{e.response.body}"
    rescue StandardError => e
      puts "Error generating preview: #{e.message}"
    end
  end
end
