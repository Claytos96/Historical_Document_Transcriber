class TextToTranscription < ActiveRecord::Migration[7.1]
  def change
    rename_column :documents, :text, :transcription
  end
end
