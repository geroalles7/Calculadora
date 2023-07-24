function calcular() {
    var num1 = parseFloat(document.getElementById('num1').value);
    var num2 = parseFloat(document.getElementById('num2').value);
    var operacion = document.querySelector('input[name="operacion"]:checked').value;
    var resultado;
  
    switch (operacion) {
      case "suma":
        resultado = num1 + num2;
        break;
      case 'resta':
        resultado = num1 - num2;
        break;
      case 'multiplicacion':
        resultado = num1 * num2;
        break;
      case 'division':
        resultado = num1 / num2;
        break;
      default:
        resultado = 'Operación no válida';
        break;
    }
    console.log(resultado);
    document.getElementById('resultado').textContent = resultado;
  }
  
