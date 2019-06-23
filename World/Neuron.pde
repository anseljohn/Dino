class Neuron {
  float weight;
  float rate = 0.00001;
  
  Neuron() {
    weight = random(-1, 1);  
  }
  
  int guess(float input) {
    return (int) Math.signum(input * weight);  
  }
  
  void train(float input, float target) {
    weight += (target - guess(input)) * input * rate;
  }
}
