# Make predictions using the loaded model
import pandas as pd
import numpy

def predict_saldo_inversion(model,X):
    predictions = model.predict(X.reshape(-1,1))
    predicted_df = pd.DataFrame({'predicted_saldo_inversion': predictions})
    return predicted_df
