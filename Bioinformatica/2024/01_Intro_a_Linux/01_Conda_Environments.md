### Week 01: Conda environments
Tópicos avanzados en Bioestadística y Bioinformática
Doctorado en Ciencias e Innovación en Medicina
Universidad del Desarrollo, Chile 2023

> Chat GPT prompt: *Describe how to create and manage conda environments*

> Conda is a popular package and environment management system used in data science and bioinformatics. Conda allows users to create isolated environments with specific package versions and dependencies, which can be particularly useful when working on different projects or with different software requirements. Here's a general guide on how to create and manage conda environments:

1. Install Conda: First, you need to install Conda on your computer. You can download and install the Anaconda distribution, which includes Conda as well as a number of commonly used packages and tools.

2. Create a new environment: To create a new environment, open a terminal or Anaconda prompt and type the following command: `conda create --name env_name. Replace "env_name"` with the desired name of your environment. You can also specify which packages to install in the new environment by adding them after the environment name, separated by spaces.

3. Activate the environment: Once you've created a new environment, you need to activate it to start using it. To activate an environment, type the command `conda activate env_name` in your terminal or prompt, again replacing "env_name" with the name of your environment. You should see the environment name in your command prompt to confirm that it is active.

4. Install packages: Once you've activated your environment, you can install packages using the conda install command followed by the package name. You can specify the version of the package to install by adding "=" and the version number, or by using the ">" or "<" operators to specify a range of acceptable versions. For example, `conda install pandas=1.2.3` installs version 1.2.3 of the Pandas package, while `conda install numpy>1.20` installs any version of Numpy greater than 1.20.

5. Save and share environments: You can save the packages and dependencies in your environment to a YAML file using the command `conda env export > environment.yml`. This creates a file called "environment.yml" that contains a list of all the packages and their versions. You can share this file with others or use it to recreate the same environment on another machine by running the command `conda env create -f environment.yml`.

6. Deactivate and remove environments: When you're finished working in an environment, you can deactivate it by typing `conda deactivate` in your terminal or prompt. To remove an environment entirely, use the command `conda env remove -n env_name`, again replacing "env_name" with the name of the environment you want to delete.

> Overall, Conda provides a flexible and powerful way to manage environments and packages in data science and bioinformatics projects. By following these steps, you can create, activate, and manage Conda environments to suit your specific needs.

> Watch: *Master the basics of Conda environments in Python* by Erick Martins [[YouTube]](https://www.youtube.com/watch?v=1VVCd0eSkYc)
