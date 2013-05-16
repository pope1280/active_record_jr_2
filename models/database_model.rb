require 'sqlite3'

module Database
  class InvalidAttributeError < StandardError;end
  class NotConnectedError < StandardError;end

  class Model

    attr_reader :attributes, :old_attributes
    
    def initialize(attributes = {})
      attributes.symbolize_keys!
      raise_error_if_invalid_attribute!(attributes.keys)

      @attributes = {}

      self.class.attribute_names.each do |name|
        @attributes[name] = attributes[name]
      end

      @old_attributes = @attributes.dup
    end

    def save
      if new_record?
        results = insert!
      else
        results = update!
      end

      @old_attributes = @attributes.dup

      results
    end

    def [](attribute)
      raise_error_if_invalid_attribute!(attribute)

      @attributes[attribute]
    end

    def []=(attribute, value)
      raise_error_if_invalid_attribute!(attribute)

      @attributes[attribute] = value
    end

    def self.all(table)
      Database::Model.execute("SELECT * FROM #{table}").map do |row|
        self.new(row)
      end
    end

    def self.create(attributes)
      record = self.new(attributes)
      record.save

      record
    end
 
    def self.where(query, *args)
      Database::Model.execute("SELECT * FROM #{self.to_s.downcase + 's'} WHERE #{query}", *args).map do |row|
        self.new(row)
      end
    end

    def self.inherited(klass)
    end

    def self.connection
      @connection
    end

    def self.filename
      @filename
    end

    def self.database=(filename)
      @filename = filename.to_s
      @connection = SQLite3::Database.new(@filename)

      @connection.results_as_hash  = true

      @connection.type_translation = true
    end

    def self.attribute_names
      @attribute_names
    end

    def self.attribute_names=(attribute_names)
      @attribute_names = attribute_names
    end

    def self.execute(query, *args)
      raise NotConnectedError, "You are not connected to a database." unless connected?

      prepared_args = args.map { |arg| prepare_value(arg) }
      Database::Model.connection.execute(query, *prepared_args)
    end

    def self.last_insert_row_id
      Database::Model.connection.last_insert_row_id
    end

    def self.connected?
      !self.connection.nil?
    end

    def raise_error_if_invalid_attribute!(attributes)
   
      Array(attributes).each do |attribute|
        unless valid_attribute?(attribute)
          raise InvalidAttributeError, "Invalid attribute for #{self.class}: #{attribute}"
        end
      end
    end

    def to_s
      attribute_str = self.attributes.map { |key, val| "#{key}: #{val.inspect}" }.join(', ')
      "#<#{self.class} #{attribute_str}>"
    end

    def valid_attribute?(attribute)
      self.class.attribute_names.include? attribute
    end

    private
    def self.prepare_value(value)
      case value
      when Time, DateTime, Date
        value.to_s
      else
        value
      end
    end
  end
end
