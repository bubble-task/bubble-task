class TagWordsValidator < ActiveModel::EachValidator

  def validate_each(record, attribute, value)
    record.class.tags_from(value).each do |tag|
      if tag.size >= 17
        record.errors.add(attribute, "「#{tag}」は16文字以内で入力してください")
      end
    end
  end
end
