import matplotlib.pyplot as plt
import streamlit as st

# Plotting regression
def linear_regression_plot(X,y,predicted_df):
    plt.figure(figsize=(10, 5))
    plt.scatter(X, y, color='blue', label='Actual', alpha=0.6)
    plt.plot(X, y, color='red')
    plt.plot(X, predicted_df, color='green', linewidth=2, label='Trend Line')
    plt.xlabel("""Index ("Representando tiempo") """)
    plt.ylabel('Saldo de Inversion')
    plt.title('Predicción de Saldo de Inversion')
    plt.legend()
    plt.grid(True)
    st.pyplot(plt)