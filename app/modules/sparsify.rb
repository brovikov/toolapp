module Sparsify
  def sparse(options = {})
    map { |k, v|
      prefix = if options[:tool_name]
        (options.fetch(:prefix, [options.fetch(:tool_name)]) + [k])
      else
        (options.fetch(:prefix, []) + [k])
      end
      next Sparsify.sparse(v, options.merge(prefix: prefix)) if v.is_a? Hash
      {prefix.join(options.fetch(:separator, "_")) => v}
    }.reduce(:merge) || {}
  end

  def unsparse(options = {})
    ret = {}
    sparse(options).each do |k, v|
      current = ret
      key = k.to_s.split(options.fetch(:separator, "_"))
      current = (current[key.shift] ||= {}) until key.size <= 1
      current[key.first] = v
    end
    ret
  end

  def self.sparse(hsh, options = {})
    hsh.dup.extend(self).sparse(options)
  end

  def self.unsparse(hsh, options = {})
    hsh.dup.extend(self).unsparse(options)
  end

  def self.extended(base)
    raise ArgumentError, "<#{base.inspect}> must be a Hash" unless base.is_a? Hash
  end
end
