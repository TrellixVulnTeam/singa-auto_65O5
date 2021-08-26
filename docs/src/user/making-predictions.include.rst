Send a ``POST /predict`` to ``predictor_host`` with a body of the following format in JSON:

    ::

        {
            "query": <query>
        }

...where the format of ``<query>`` depends on the associated task (see :ref:`tasks`).

The body of the response will be of the following format in JSON:

    ::

        {
            "prediction": <prediction>
        }

...where the format of ``<prediction>`` depends on the associated task.


Example:

    If ``predictor_host`` is ``127.0.0.1:30000``, run the following in Python:

        .. code-block:: python
        
            predictor_host = '127.0.0.1:30000'
            query_path = 'examples/data/image_classification/fashion_mnist_test_1.png'

            # Load query image as 3D list of pixels
            from singa_auto.model import utils
            [query] = utils.dataset.load_images([query_path]).tolist()

            # Make request to predictor
            import requests
            import json
            res = requests.post('http://{}/predict'.format(predictor_host), json={ 'query': query })
            print(res.json())

    Output:

        .. code-block:: python

            {'prediction': [0.9364003576825639, 1.016065009906697e-08, 0.0027604885399341583, 0.00014587241457775235, 6.018594376655528e-06, 1.042887332047826e-09, 0.060679372351310566, 2.024707311532037e-11, 7.901770004536957e-06, 1.5299328026685544e-08], 
            'predictions': []}


Prediction for QuestionAnswering
----------------------------
The query question should be uploaded by the following format
        .. code-block:: python
        
            data={"questions": ["How long individuals are contagious?"]}
            res = requests.post('http://{}/predict'.format(predictor_host), json=data)

To print out the prediction result, you should use 'res.text'
        .. code-block:: python
        
            print(res.text)


Prediction for SpeechRecognition 
----------------
The query data is passed using the following steps
        .. code-block:: python
        
        data = ['data/ldc93s1/ldc93s1/LDC93S1.wav']
        data = json.dumps(data)
        res = requests.post('http://{}/predict'.format(predictor_host), json=data[0])

To print out the prediction result, you should use 'res.text'
        .. code-block:: python
        
            print(res.text)


If the SINGA-Auto instance is deployed with Kubernetes, all the inference job are at the default Ingress port 3005 with the format of <host>:3005/<app>, where <host> is the host name of the SINGA-Auto instance, and <app> is the name of the application prodvided when we submit train jobs.
