<?php
if(session_status()===PHP_SESSION_NONE){
    session_start();
}
if (isset($_SESSION['user_id'])) {
    header("Location: index.php?page=dashboard");
    exit();
}
$thong_bao = "";
if(isset($_POST['btn-login'])){
    $username = $_POST['username'];
    $password = $_POST['password'];
    if($username=="" || $password==""){
        $thong_bao = "Vui lòng nhập đầy đủ tài khoản và mật khẩu!";
    }else{
        $sql = "SELECT * FROM users WHERE username = '$username' AND password = '$password' AND status = 1";
        $ket_qua = mysqli_query($con, $sql);
        if(mysqli_num_rows($ket_qua)==1){
           $user = mysqli_fetch_assoc($ket_qua);
           $_SESSION['user_id'] = $user['id'];
           $_SESSION['username'] = $user['username'];
           $_SESSION['name'] = $user['name'];
           $_SESSION['user_level'] = $user['user_level'];
           echo "<script>
                    alert('Đăng nhập thành công! Xin chào " . $user['name'] . "');
                    window.location.href = 'index.php?page=dashboard';
                </script>";
            exit();
        }else{
            $thong_bao="Sai tên đăng nhập hoặc mật khẩu!";
        }
    }
}
?>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <!-- css boottrap -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.9/dist/css/bootstrap.min.css" rel="stylesheet" integrity="sha384-yEPZ7jP9S0QKiUQ0m3jjsO4ProIW7wvR9gXkI7JOGa2XVsw53Yke2bsdkBbjmmiX" crossorigin="anonymous">
    <title>Đăng Nhập - Quản Lý Kho</title>
</head>
<body class="bg-light">
    <div class="container" style="margin-top:100px">
        <div class="row justify-content-center" >
            <div class="col-md-4">
                <div class="card shadow">
                    <div class="card-header bg-primary text-white text-center py-3">
                        <h4 class="mb-0">ĐĂNG NHẬP KHO HÀNG</h4>
                    </div>
                    <div class="card-body p-4">
                       <?php if ($thong_bao != "") { ?>
                            <div class="alert alert-danger">
                                <?php echo $thong_bao; ?>
                            </div>
                        <?php } ?>
                        <form action="" method="post">
                            <div class="mb-3">
                                <label for="" class="form-label">Tên đăng nhập:</label>
                                <input type="text" name="username" class="form-control" placeholder="Nhập Username....." required>
                            </div>
                            <div class="mb-3">
                                <label for="" class="form-label">Mật Khẩu:</label>
                                <input type="password" name="password" class="form-control" placeholder="Nhập mật khẩu ....." required>
                            </div>
                            <button class="btn btn-primary w-100 py-2" type="submit" name="btn-login">Đăng Nhập</button>
                    </div>
                    
                </div>
            </div>
        </div>
    </div>

    <!-- js boottrap -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.9/dist/js/bootstrap.bundle.min.js" integrity="sha384-WyOxWvTyr1QaMPfiPJSv76iReVthorl5uWlFtZPyK0IEB0hGzo9y5Bp9mYanr8Bu" crossorigin="anonymous"></script>

</body>
</html>