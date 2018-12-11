var blockchain = "";
$(function (){
    var wallet_chart;
    var miner_chart;
    console.log("Simulation started");


   init_wallet_chart();
   init_miner_chart();
   
   $("#start-simulation").click(function () {
      data = [50,34,50,29,90,70];
       update_miner_data(data);
   });
   

   $.get("/simulate", function (data) {
       console.log(data);
       blockchain = data;
       blockchain.reverse();
       render();
   })
    function render(){
      var chainBlocks = "";
      var i =0;
      blockchain.forEach(function (data) {
           i++;
           var element = `<div class="card m-auto mt-2 my-auto" style="width: 50rem;">
          <div class="card-body">
              <h4 class="card-title">Block ${i}</h4>
          <h6 class="card-subtitle mb-2 text-muted">Transaction</h6>
          <p class="card-text">Amount: ${data.data.amount}</p>
          <p class="card-text">From Address: ${data.data.fromAddress}</p>
          <p class="card-text">To Address: ${data.data.toAddress}</p>
          
          <h6 class="card-subtitle mb-2 text-muted">Hash</h6>
          <p class="card-text">${data.hash}</p>
          <h6 class="card-subtitle mb-2 text-muted">Prev Hash</h6>
          <a href="#" class="card-link"><p class="card-text">${data.prev_hash}</p></a>
          
          </div>
          </div>`
          $("#blockchain").append(element)

      })
    }
    
    function update_miner_data(new_data) {
        miner_chart.data.datasets[0].data = new_data;
        miner_chart.update();
    }

    function init_wallet_chart(){
        var ctx = document.getElementById("wallet_chart").getContext('2d');
        wallet_chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: ["Wallet1", "Wallet2", "Wallet3", "Wallet4", "Wallet5", "Wallet6"],
                datasets: [{
                    label: '# Wallet with bitcoins',
                    data: [11, 19, 3, 5, 2, 3],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255,99,132,1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        });
    }
   
    
    function init_miner_chart() {
        var ctx2 = document.getElementById("miner_chart").getContext('2d');
        miner_chart = new Chart(ctx2, {
            type: 'bar',
            data: {
                labels: ["Miner1", "Miner2", "Miner3", "Miner4", "Miner5", "Miner6"],
                datasets: [{
                    label: '# Miner with bitcoins',
                    data: [0, 1, 2, 3, 4, 5],
                    backgroundColor: [
                        'rgba(255, 99, 132, 0.2)',
                        'rgba(54, 162, 235, 0.2)',
                        'rgba(255, 206, 86, 0.2)',
                        'rgba(75, 192, 192, 0.2)',
                        'rgba(153, 102, 255, 0.2)',
                        'rgba(255, 159, 64, 0.2)'
                    ],
                    borderColor: [
                        'rgba(255,99,132,1)',
                        'rgba(54, 162, 235, 1)',
                        'rgba(255, 206, 86, 1)',
                        'rgba(75, 192, 192, 1)',
                        'rgba(153, 102, 255, 1)',
                        'rgba(255, 159, 64, 1)'
                    ],
                    borderWidth: 1
                }]
            },
            options: {
                scales: {
                    yAxes: [{
                        ticks: {
                            beginAtZero:true
                        }
                    }]
                }
            }
        });
    }

});