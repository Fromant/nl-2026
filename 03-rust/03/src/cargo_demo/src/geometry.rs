pub struct Point {
    pub x: f64,
    pub y: f64,
}

pub fn dist(a: &Point, b: &Point) -> f64 {
    helper(a.x - b.x, a.y - b.y)
}

fn helper(dx: f64, dy: f64) -> f64 {
    (dx * dx + dy * dy).sqrt()
}

#[cfg(test)]
mod tests {
    use super::*;

    #[test]
    fn dist_3_4_5() {
        let a = Point { x: 0.0, y: 0.0 };
        let b = Point { x: 3.0, y: 4.0 };
        assert_eq!(dist(&a, &b), 5.0);
    }
}
