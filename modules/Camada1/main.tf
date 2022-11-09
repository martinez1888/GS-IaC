#SECURITY GROUP
resource "aws_security_group" "sg_pub" {
  name        = "sg_pub"
  vpc_id      = var.vpcgs_id

  egress {
    description = "All to All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All from 10.0.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.0.0.0/16"]
  }

  ingress {
    description = "TCP/22 from All"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "TCP/80 from All"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "sg_pub"
  }
}

resource "aws_security_group" "sg_priv1" {
  name        = "sg_priv1"
  vpc_id      = var.vpcgs_id

  egress {
    description = "All to All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All from 10.1.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
  }
  
    ingress {
    description = "All from 10.2.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.2.0.0/16"]
  }

  tags = {
    Name = "sg_priv1"
  }
}

resource "aws_security_group" "sg_priv2" {
  name        = "sg_priv2"
  vpc_id      = var.vpcgs_id

  egress {
    description = "All to All"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "All from 10.3.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.1.0.0/16"]
  }
  
    ingress {
    description = "All from 10.4.0.0/16"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["10.2.0.0/16"]
  }

  tags = {
    Name = "sg_priv2"
  }
}

#EC2 LAUNCH TEMPLATE
data "template_file" "user_data" {
  template = file("./modules/ec2/userdata-notifier.sh")
}

resource "aws_launch_template" "lt_app_notify1" {
  name                   = "lt_app_notify1"
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_pub.id]
  key_name               = var.ssh_key
  user_data              = base64encode(data.template_file.user_data.rendered)


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app_notify1"
    }
  }

  tags = {
    Name = "lt_app_notify1"
  }
}

data "template_file" "user_data" {
  template = file("./modules/ec2/userdata-notifier.sh")
  vars = {
    rds_endpoint = "${var.rds_endpoint}"
    rds_user     = "${var.rds_user}"
    rds_password = "${var.rds_password}"
    rds_name     = "${var.rds_name}"
  }
}

resource "aws_launch_template" "lt_app_notify2" {
  name                   = "lt_app_notify2"
  image_id               = var.ami
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.sg_priv1.id]
  key_name               = var.ssh_key
  user_data              = base64encode(data.template_file.user_data.rendered)


  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "app_notify2"
    }
  }

  tags = {
    Name = "lt_app_notify2"
  }
}

#AUTOSCALING GROUP
resource "aws_autoscaling_group" "asg_pub" {
  name                = "asg_pub"
  vpc_zone_identifier = ["${var.sn_vpcgs_1a_id}", "${var.sn_vpcgs_1c_id}"]
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  target_group_arns   = [aws_lb_target_group.tg_app_notify1.arn]

  launch_template {
    id      = aws_launch_template.lt_app_notify1.id
    version = "$Latest"
  }

}
  
  resource "aws_autoscaling_group" "asg_riv" {
  name                = "asg_pub"
  vpc_zone_identifier = ["${var.sn_vpcgs_2a_id}", "${var.sn_vpcgs_2c_id}"]
  desired_capacity    = var.desired_capacity
  min_size            = var.min_size
  max_size            = var.max_size
  target_group_arns   = [aws_lb_target_group.tg_app_notify2.arn]

  launch_template {
    id      = aws_launch_template.lt_app_notify2.id
    version = "$Latest"
  }

}

#LOAD BALANCER
resource "aws_lb" "elb_pub" {
  name               = "elb-pub"
  load_balancer_type = "application"
  subnets            = [var.sn_vpcgs_1a_id, var.sn_vpcgs_1c_id]
  security_groups    = [aws_security_group.sg_pub.id]

  tags = {
    Name = "elb_pub"
  }
}
  
  resource "aws_lb" "elb_priv" {
  name               = "elb-priv"
  load_balancer_type = "application"
  subnets            = [var.sn_vpcgs_2a_id, var.sn_vpcgs_2c_id]
  security_groups    = [aws_security_group.sg_priv1.id]

  tags = {
    Name = "elb_priv"
  }
}

#LOAD BALANCER TARGET GROUP
resource "aws_lb_target_group" "tg_app_notify1" {
  name     = "tg-app-notify1"
  vpc_id   = var.vpcgs_id
  protocol = var.protocol
  port     = var.port

  tags = {
    Name = "tg_app_notify1"
  }
}
  
  resource "aws_lb_target_group" "tg_app_notify2" {
  name     = "tg-app-notify2"
  vpc_id   = var.vpcgs_id
  protocol = var.protocol
  port     = var.port

  tags = {
    Name = "tg_app_notify2"
  }
}

#LOAD BALANCER LISTENER
resource "aws_lb_listener" "listener_app_notify1" {
  load_balancer_arn = aws_lb.elb_pub.arn
  protocol          = var.protocol
  port              = var.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_app_notify1.arn
  }
}
  
  resource "aws_lb_listener" "listener_app_notify2" {
  load_balancer_arn = aws_lb.elb_priv.arn
  protocol          = var.protocol
  port              = var.port

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.tg_app_notify2.arn
  }
}
  
  #EFS
  
