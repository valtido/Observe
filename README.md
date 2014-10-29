Observe
=======

Recursive Object Observer 

This helps and reports back for any changes that may happen to an object, reports back the `path` and the `value` it has changed into.


This is a coffee script atm (as it's only first draft)

#testing

```
npm test
``` 

#how it works

```js
parson = {name: "Tom", age: 18}

new Observe( person , function (changes, original){
  console.log(changes);
} )



person.name = "Ben";   // {value: "Ben", path: name}
person.age = 20;   // {value: 20, path: 'age'}
```


This should also work for recursive, and future ancestors which are added into the object.


```
person.children = [{name:"Joe"} , {name: "Kim"} , {name:"Tom"} ]
person.children[1].name = 'ana'; //{value: "ana", path: 'children[1].name'}
```

This object is especially useful when binding (one way or two-way) to listen for changes taking advantage of the native `Object.observe(obj, callback)` aka `O.o` in a recursive mode, therefore performance should be optimal.


*Raise a ticket if you would like to contribute.*







