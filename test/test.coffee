xcollection =
  Collection:
    profile :[
      name: "Valtid"
      age: "26"
    ]
person =
  age: 18
  name:
    birth:
      first:'Valtid'
      last: 'Caushi'
    current:
      first:'Lee'
      last: 'Mack'
  children:['Tom','Ben','Mike']
  mixed: [
    'Manchester'
    'London'
    {"town":"barnet", "interests":['Museum','Library','Football']}
    'liverpool'
  ]
result = null

new Observe person, (changes)->
  for key,item of changes
    result = item

new Observe xcollection.Collection, (changes)->
  for key,item of changes
    result = item

describe "Observer", ->
  beforeEach (done)->
    setTimeout ->
      result = null
      done()
    , 1

  it "should notify age change", (done) ->
    person.age = 20

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "age"
      expect(result.value).toBe 20
      done()
    , 10


  it "should notify when array is popped", (done) ->
    person.children.pop()

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "children[2]"
      expect(result.value[0]).toBe "Tom"
      expect(result.value[1]).toBe "Ben"
      done()
    , 10


  it "should notify when array is pushed", (done) ->
    person.children.push "Joe"

    setTimeout ->
      # debugger
      expect(result).not.toBe null
      expect(result.path).toBe "children[2]"
      expect(result.value).toBe "Joe"
      done()
    , 10

  it "should notify when array is modified directly", (done) ->
    person.children[2]="Kim"

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "children[2]"
      expect(result.value).toBe "Kim"
      done()
    , 10


  it "should notify when array is sorted", (done) ->
    person.children.sort()

    setTimeout ->

      expect(result).not.toBe null
      expect(person.children[0]).toBe "Ben"
      expect(person.children[1]).toBe "Kim"
      expect(person.children[2]).toBe "Tom"
      done()
    , 20




  it "should notify when deep chanin", (done) ->
    person.name.birth.first = 'Valtido'

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "name.birth.first"
      expect(result.value).toBe "Valtido"
      done()
    , 20


  it "should notify when adding deep chanin", (done) ->
    person.name.birth.middle = 'Blah'

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "name.birth.middle"
      expect(result.value).toBe "Blah"
      done()
    , 20


  it "should notify when adding an object", (done) ->
    person.hair =
         color : "brown"

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "hair"
      expect(result.value.color).toBe "brown"
      done()
    , 20

  it "should notify when changing a complex deep object", (done) ->
    person.mixed[2].interests[2]='Music Festival'

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "mixed[2].interests[2]"
      expect(result.value).toBe "Music Festival"
      done()
    , 20


  it "should notify when pushing into a deep chanin", (done) ->
    # there is a fundamental problem here
    # cant push objects if they are strings
    # as you will not get notified
    # if `var alternative = "some string"`,this works fine, otherwise it doesn't
    alternative =
      "alternatives": [
        'Music_Festival',
          "tv":'bbc'
      ]
    person.mixed[2].interests.push alternative


    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "mixed[2].interests[3]"
      expect(result.value.alternatives[1].tv).toBe "bbc"
      done()
    , 20


  it "should notify when changing a deep complex obj in the future", (done) ->
    person.mixed[2].interests[3].alternatives[1].tv="ITV"

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "mixed[2].interests[3].alternatives[1].tv"
      expect(result.value).toBe "ITV"
      done()
    , 20

  it "should notify when changing a deep super complex future obj", (done) ->
    xcollection.Collection.profile.push
      name: "Ton"
      age: 18

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "profile[1]"
      expect(result.value.name).toBe "Ton"
      expect(result.value.age).toBe 18
      done()
    , 20
  it "should notify when changing a deep super complex future obj 2", (done) ->
    xcollection.Collection.profile[1].name = "Tom"

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "profile[1].name"
      expect(result.value).toBe "Tom"
      done()
    , 20
