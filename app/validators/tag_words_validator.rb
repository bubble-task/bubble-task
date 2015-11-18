class TagWordsValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.class.tags_from(value).each do |tag|
      tag.size >= 17 && add_error(record, attribute, tag)
    end
  end

  private

    def add_error(record, attribute, tag)
      record.errors.add(attribute, "「#{tag}」は16文字以内で入力してください")
    end
end
