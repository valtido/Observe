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
  mixed: ['Manchester','London',{"town":"barnet", "interests":['Museum','Library','Football']},'liverpool']

result = null

new Observe person, (changes)->
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
      expect(result.path).toBe "children"
      expect(result.value[0]).toBe "Tom"
      expect(result.value[1]).toBe "Ben"
      done()
    , 10


  it "should notify when array is pushed", (done) ->
    person.children.push "Joe"

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "children"
      expect(result.value[0]).toBe "Tom"
      expect(result.value[1]).toBe "Ben"
      expect(result.value[2]).toBe "Joe"
      done()
    , 10

  it "should notify when array is modified directly", (done) ->
    person.children[2]="Kim"

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "children"
      expect(result.value[0]).toBe "Tom"
      expect(result.value[1]).toBe "Ben"
      expect(result.value[2]).toBe "Kim"
      done()
    , 10


  it "should notify when array is sorted", (done) ->
    person.children.sort()

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "children"
      expect(result.value[0]).toBe "Ben"
      expect(result.value[1]).toBe "Kim"
      expect(result.value[2]).toBe "Tom"
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
      expect(result.path).toBe "mixed[2].interests"
      expect(result.value[2]).toBe "Music Festival"
      done()
    , 20


  it "should notify when pushing into a deep chanin", (done) ->
    person.mixed[2].interests.push { alternatives: ['Music Festival',{"tv":'bbc'}] }

    setTimeout ->
      expect(result).not.toBe null
      expect(result.path).toBe "mixed[2].interests"
      expect(result.value[3].alternatives[1].tv).toBe "bbc"
      done()
    , 20


  it "should notify when changing a deep complex object in the future", (done) ->
    person.mixed[2].interests[3].alternatives[1].tv="ITV"

    setTimeout ->
      console.log JSON.stringify result
      expect(result).not.toBe null
      expect(result.path).toBe "mixed[2].interests[3].alternatives[1].tv"
      expect(result.value).toBe "ITV"
      done()
    , 20
