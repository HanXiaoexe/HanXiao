<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="zh">
<head>
  <meta charset="UTF-8">
  <title>添加试题</title>
  <link href="https://cdn.bootcdn.net/ajax/libs/twitter-bootstrap/4.6.2/css/bootstrap.min.css" rel="stylesheet">
  <script src="http://libs.baidu.com/jquery/2.0.0/jquery.min.js"></script>

</head>
<body>
<div class="container">
  <h1 class="mt-4">添加试题</h1>
  <form action="QuestionAddServlet" method="post">
    <div class="form-group">
      <label for="questionText">题目</label>
      <input type="text" class="form-control" name="questionText" id="questionText" required>
    </div>
    <div class="form-group">
      <label for="optionA">A 选项</label>
      <input type="text" class="form-control" name="optionA" id="optionA" required>
    </div>
    <div class="form-group">
      <label for="optionB">B 选项</label>
      <input type="text" class="form-control" name="optionB" id="optionB" required>
    </div>
    <div class="form-group">
      <label for="optionC">C 选项</label>
      <input type="text" class="form-control" name="optionC" id="optionC" required>
    </div>
    <div class="form-group">
      <label for="optionD">D 选项</label>
      <input type="text" class="form-control" name="optionD" id="optionD" required>
    </div>
    <div class="form-group">
      <label for="answer">正确答案</label>
      <select class="form-control" name="answer" id="answer" required>
        <option value="A">A</option>
        <option value="B">B</option>
        <option value="C">C</option>
        <option value="D">D</option>
      </select>
    </div>
    <button type="submit" class="btn btn-primary">添加试题</button>
  </form>
</div>



</body>
</html>