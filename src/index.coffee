class Observe
  constructor: (root, callback, curr=null, path = null)->
    curr = curr or root

    type_of_curr = curr.constructor.name
    if type_of_curr is "Array"
      base = path
      for item, key in curr
        if typeof item is "object"
          new_path = "#{base or ''}[#{key}]"
          new Observe root, callback, item, new_path
          new_path = ""

    if type_of_curr is "Object"
      base = path
      for key, item of curr
        # if item.constructor.name is "Object"
        if typeof item is "object"
          new_path = "#{base}.#{key}" if base
          new_path = "#{key}" unless base
          new Observe root, callback, item, new_path
          new_path = ""


    if curr.constructor.name is "Array"
      base = path
      Array.observe curr, (changes) ->
        result = {}
        original = {}

        changes.forEach (change,i) ->
          index_or_name = if change.index>-1 then change.index else change.name
          new_path = "#{base or ''}[#{index_or_name}]"
          # console.log change
          part =
            path: new_path
            value : change.object[change.index] or
                    change.object[change.name] or
                    change.object
            # json : JSON.stringify(change.object)
          # if change.type is "add" and typeof part.value is "object"

          is_add = change.addedCount > 0 or change.type is "add"
          if typeof part.value is "object" and is_add
            new Observe root, callback, part.value, part.path
            new_path = ""
          result[i] = part
          original[i] = change
        callback result, original
    else if curr.constructor.name is "Object"
      base = path
      Object.observe curr, (changes)->
        result = {}
        original = {}

        changes.forEach (change,i) ->
          new_path = "#{base}.#{change.name}" if base
          new_path = "#{change.name}" unless base

          part =
            path: new_path
            value : change.object[change.name]

          is_add = change.type is "add" or change.addedCount > 0
          if typeof part.value is "object" and is_add
            new Observe root, callback, part.value, part.path
            new_path = ""
          result[i] = part
          original[i] = change
        callback result, original
