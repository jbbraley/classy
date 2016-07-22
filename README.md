# matlab class definition magic

classy.m is a matlab classdef utility function.

# examples

## create a stand-alone custom class

create instance of classy
```
c = classy()
```

view methods
```
methods(c)
```

change the name of your custom class
```
c.name = 'myclass';
```

*note that the dependent property 'fullname' was updated* - view this with `c.fullname`


generate class definition code in default C:\Temp directory
    *note:* by passing a false boolean to the create_class() method we are saying that we do not want to create the class folder @myclass
```
c.create_class(0)
```

## create a custom class - folder version
begin with the same basic process as a stand-alone class
```
c = classy();
c.name = 'myclass';
```

when creating the full class folder and file either call the `create()` method with no inputs or explicitly pass a true boolean  
```
c.create() % c.create(1) works also
```

this creates the folder `@myclass` and places the classdef file `myclass.m` inside of it (or appended if you messed up and called it twice).

*note that the c.fullname property was updated after the `create()` method was called but not before*
