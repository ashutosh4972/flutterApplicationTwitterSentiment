from flask import Flask, request, jsonify

import json

from keras.models import load_model

import numpy as np

model = load_model('Sentiment_CNN_model.h5')

with open( 'sentiment_analysis_result.json') as json_file :
    json_tokenizer = json.load(json_file)
    
def tokenize(comment):
    new_commentlists = []
    new_commentlist = []
    
    for word in comment.split():
        word = word.lower()
        if(len(new_commentlist) < 100 and word in json_tokenizer):
            new_commentlist.append(json_tokenizer[word])
            
    if(len(new_commentlist) < 100):
        zeroes = list(np.zeros(100 - len(new_commentlist), dtype=int))
        new_commentlist = zeroes + new_commentlist
    new_commentlists.append(new_commentlist)
    
    return np.array(new_commentlists, dtype=np.dtype(np.int32))

app = Flask(__name__)

array = {'output' : ""}

@app.route('/', methods = ['POST' , 'GET'])

def index():
    finalResult = ""
    request_data = json.loads(request.data.decode('utf-8'))
    
    text_from_app = request_data['text']
    print(text_from_app)
    token_text = tokenize(text_from_app)
    
    sentiment_result = model.predict_classes(token_text)
    print(sentiment_result[0][0])
    
    sentiment_score = model.predict(token_text)
    print(sentiment_score[0][0])
    
    
    if(sentiment_result[0][0] == 1):
        finalResult = "Positive"
    else:
        finalResult = "Negative"
        
    array['sentiment'] = finalResult
    array['score'] = str(sentiment_score[0][0])
    
    return jsonify(array)

if __name__ == '__main__' :
    app.run(host= '0.0.0.0', debug=True)