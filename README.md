# GeoSpatial Lambda Layer 

Python geospatial lambda layer including:

- shapely
- osgeo
- rasterio
- numpy
- pillow


# Deploy

Prerequisites:

- awscli
- aws-sam-cli
- docker
- make
- awscfncli2

Deploy:


    $ make
    $ AWS_PROFILE=<your-profile-here> make deploy

Note the `make` will pull and build a very large docker image and may take 
a while.  Goto `geo_layer` and run `docker build .` to see what's happening 
if you encounter problems.

After everything is deployed, check stack output:

    $ cfn-cli --profile=<your-profile-here> status -e
    Default.GeoLamb
    StackName: GeoLambHelloWorld
    Status: CREATE_COMPLETE
    StackID: arn:aws:cloudformation:us-east-1:1234567890:stack/GeoLambHelloWorld/XXXXXXXXX
    Created: 2018-12-11 08:39:27.082000+00:00
    Last Updated: 2018-12-11 08:57:17.121000+00:00
    Capabilities: ['CAPABILITY_IAM']
    TerminationProtection: False
    Outputs: 
      HelloWorldFunctionIamRole: arn:aws:iam::1234567890:role/GeoLambHelloWorld-HelloWorldFunctionRole-XXXXXXXXX
      HelloWorldApi: https://XXXXXXXXX.execute-api.us-east-1.amazonaws.com/Prod/hello/
      HelloWorldFunction: arn:aws:lambda:us-east-1:877602539438:function:GeoLambHelloWorld-HelloWorldFunction-XXXXXXXXX
    Exports: 


Call the lambda function: 

    $ curl https://XXXXXXXXX.execute-api.us-east-1.amazonaws.com/Prod/hello/

    {"geos_version": "2030200", "shapely_geometry": "POINT (1.0000000000000000 2.0000000000000000)"}⏎      

# How Python Lambda Layer (Actually) Works

The official documentation is quite obscure on the internals, and only tells 
how to create a layer when someone has created the "many-linux wheel" packages.

If you want include custom binary in the layer:

- Everything in the lambda function package still goes to `/var/task`,
- Everything in the lambda layer goes to `/opt`,
- Python run time will have (besides the usual `/var/task` stuff`): 
    - `PATH` set to `opt/bin`
    - `LD_LIBRARY_PTH` set to `opt/lib`
    - `PYTHON_PATH` set to `/opt/python` and `/opt/python/lib/python<version>/site-packages/`

So, this means: 
- If custom binary dependency is configured to installed in `/opt`
- And python packages installed in `/opt/python/lib/python<version>/site-packages/` 

We can simply zip-up `/opt` as a layer, Check [Dockerfile](geo_layer/Dockerfile) for details.
