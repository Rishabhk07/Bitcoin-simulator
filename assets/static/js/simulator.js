var blockchain = "";
$(function (){
    $("#ins-card").hide();
    var wallet_chart;
    var miner_chart;
    console.log("Simulator here No Simulation");

    var miner_keys = "";
    var wallet_keys = "";
    init_wallet_chart();
    init_miner_chart();

    $("#start-simulation").click(function (label) {
        $("#start-simulation").hide(10);
        $("#ins-card").show(10);
        $.get("/get_miner_keys", function (data) {
            // console.log(data);
            miner_keys = data;
        })
        $.get("/get_wallet_keys", function(data){
            console.log(data);
            wallet_keys = data
        })
        // data = [50,34,50,29,90,70];
        // data2 = [Math.floor(Math.random() * 50) + 1,Math.floor(Math.random() * 100) + 1,Math.floor(Math.random() * 30) + 1,29,90,70];
        //
        //  update_miner_data(data);
        //  update_wallet_data(data2);
        setTimeout(mine_block, 2000);
    });
    var miner_count =0;
    function mine_block() {
        
        $.get("/blockchain_valid", function (data) {
            console.log("SEEEE HERE !!!!!!!")
            console.log(data)
            $("#ins-card").html(`
       <h5 class="card-title " id="info">Blockchain valid = </h5>
      <div class="card-body">
        <h5 class="card-title " id="info">${data}</h5>
      </div>`)
        })
        
        miner_count++;
        $.get("/mine_block", function (data) {
            console.log(data);
            setTimeout(mine_block, 2000);
            $.get("/get_blockchain", function (data) {
                console.log(data);
                blockchain = data;
                blockchain.reverse();
                calculate_amount_miner();
                render();
            })
        })
        console.log(miner_count);
        if(miner_count >= 4){
            var randomWallet = `Wallet${Math.floor(Math.random() * 100) + 1}`;

            var miner_with_amount = []
            miner_amount.forEach(function(amount, index){
                if (amount > 0){
                    miner_with_amount.push(index)
                }
            });
            // var randoMiner =  Math.floor(Math.random() * 100) + 1;;
            var random = miner_with_amount[Math.floor(Math.random() * miner_with_amount.length)]
            console.log("KEYS MINER HERE")
            console.log(miner_keys)
            console.log(miner_keys[random])
            var to_miner = (miner_keys[random]).public;

            // console.log("MINER AMOUNT");
            // console.log(miner_actual_amount);
             var min_amount = miner_amount[random];
            var amount = Math.floor(min_amount - min_amount/2);
            // console.log("AMOUNT !!! ");
            // console.log(amount);
            $.get(`/wallet_from_miners?wallet=${randomWallet}&miner=${to_miner}&amount=${amount}`, function (data) {
                // console.log(data);
                $.get("/get_blockchain", function (data) {
                    // console.log(data);
                    blockchain = data;
                    blockchain.reverse();
                    calculate_amount_wallet();
                    render();
                })
            })
        }
    }

    function getRandomValue(){
        var randoMiner = Math.floor(Math.random() * 100) + 1;
        if(miner_amount[randoMiner] == 0){
           return getRandomValue(arr);
        }else {
            return randoMiner;
        }

    }
    var miner_amount = [];
    function calculate_amount_miner(){
        var miner_array = [];
        miner_keys.forEach(function(data){
            var sum = 0;
            blockchain.forEach( function(block_data ){
                if(data.public == block_data.data.toAddress){
                    sum = sum + block_data.data.amount;
                }
                if(data.public == block_data.data.fromAddress){
                    sum = sum - block_data.data.amount;
                }
            })
            miner_array.push(sum);
        });
        console.log(miner_array);
        miner_amount = miner_array;
        update_miner_data(miner_array);
    }

    function calculate_amount_wallet(){
        var wallet_array = [];
        wallet_keys.forEach(function(data){
            var sum = 0;
            blockchain.forEach( function(block_data ){
                if(data == block_data.data.toAddress){
                    sum = sum + block_data.data.amount;
                }
                if(data == block_data.data.fromAddress){
                    sum = sum - block_data.data.amount;
                }
            });
            wallet_array.push(sum);
        });
        console.log("wallet sum array");
        console.log(wallet_array);
        // miner_amount = miner_array;
        update_wallet_data(wallet_array);
    }

    $.get("/simulate", function (data) {
        console.log(data);
        blockchain = data;
        blockchain.reverse();
        render();
    })
    function render(){
        $("#blockchain").html('');
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

    function update_wallet_data(new_data) {
        wallet_chart.data.datasets[0].data = new_data;
        wallet_chart.update();
    }

    function init_wallet_chart(){
        var wallet = [];
        var data = [];
        var charts_color = [];
        var charts_color_pool = [       'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)']
        var border_color = []
        var border_color_pool = [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)']
        for (var i  = 1; i <= 100;i ++){
            wallet.push(`Wallet${i}`);
            data.push(0);
            var random = Math.floor(Math.random() * charts_color_pool.length)
            charts_color.push(charts_color_pool[random])
            border_color.push(border_color_pool[random])
        }
        var ctx = document.getElementById("wallet_chart").getContext('2d');
        wallet_chart = new Chart(ctx, {
            type: 'bar',
            data: {
                labels: wallet,
                datasets: [{
                    label: '# Wallet with bitcoins',
                    data: data,
                    backgroundColor: charts_color,
                    borderColor: border_color,
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
        var miner = [];
        var data = [];
        var charts_color = [];
        var charts_color_pool = [       'rgba(255, 99, 132, 0.2)',
            'rgba(54, 162, 235, 0.2)',
            'rgba(255, 206, 86, 0.2)',
            'rgba(75, 192, 192, 0.2)',
            'rgba(153, 102, 255, 0.2)']
        var border_color = []
        var border_color_pool = [
            'rgba(255,99,132,1)',
            'rgba(54, 162, 235, 1)',
            'rgba(255, 206, 86, 1)',
            'rgba(75, 192, 192, 1)',
            'rgba(153, 102, 255, 1)']
        for (var i  = 1; i <= 100;i ++){
            miner.push(`Miner${i}`);
            data.push(0);
            var random = Math.floor(Math.random() * charts_color_pool.length)
            charts_color.push(charts_color_pool[random])
            border_color.push(border_color_pool[random])
        }
        var ctx2 = document.getElementById("miner_chart").getContext('2d');
        miner_chart = new Chart(ctx2, {
            type: 'bar',
            data: {
                labels: miner ,
                datasets: [{
                    label: '# Miner with bitcoins',
                    data: data,
                    backgroundColor: charts_color,
                    borderColor: border_color,
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