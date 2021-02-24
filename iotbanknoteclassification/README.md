# Setting Up

In order to run this application, you will first need to have Flutter installed in your system. The steps on how to do this can be found [here](https://flutter.dev/docs/get-started/install).

Once you have set up FLutter, you will only need to make one change. Under './lib/main.dart', in the submitImage() function, you will need to update the url variable to the url that was provided to you when you deployed the model to Azure Machine Learning. This can be found in the Jupyter notebook in '\CX4171 Project - Bank Note Image Classification\money-image-classification'. Since each deployment will give a different url, this variable has to be changed after each redployment.
